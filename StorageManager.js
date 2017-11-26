const pgp = require('pg-promise')({
    capSQL: true
});

class StorageManager {
    constructor() {
        console.log(process.env.DATABASE_URL);
        this.db = pgp(process.env.DATABASE_URL);
    }

    // Create methods
    createMessage(messageBody) {
        return this.db.one('INSERT INTO messages(body) VALUES ($1) RETURNING id', [messageBody]).then(data => {
            return data.id;
        }).catch(error => {
            return console.error('Error with query:\n', error.message, error.stack);
        });
    }

    createTags(tagNames) {       
        return this.insertNewObjectsOnly(tagNames, 'tags', 'name');
    }

    createLinks(urls) {
        return this.insertNewObjectsOnly(urls, 'links', 'url');
    }

    createTaggedMessage(messageId, tagIds) {
        var rowsToInsert = [];
        
        tagIds.forEach(tagId => {
            var row = {};
            row.tagid = tagId;
            row.messageid = messageId;
            rowsToInsert.push(row);
        })

        return this.bulkInsert(['messageid', 'tagid'], 'tagged-messages', rowsToInsert);        
    }

    createTaggedLinks(linkIds, tagIds) {
        let queryString = 'SELECT * FROM "tagged-links" WHERE "linkid" IN ($1:csv) AND tagid IN ($2:csv)';
        return this.db.any(queryString, [linkIds, tagIds]).then(data => {
            // Find linkIds which need to be inserted
            let preExistingLinkIds = data.map(d => d.linkid);
            let newLinkIds = linkIds.filter(id => !preExistingLinkIds.includes(id));

            // Find tagIds which need to be inserted
            let preExistingTagIds = data.map(d => d.tagid);
            let newTagIds = tagIds.filter(id => !preExistingTagIds.includes(id));

            // Create rows to insert
            var rowsToInsert = [];

            // For any new link, create a tagged-link entry with that new link and all tags
            newLinkIds.forEach(linkId => {
                tagIds.forEach(tagId => {
                    var row = {};
                    row.linkid = linkId,
                    row.tagid = tagId

                    rowsToInsert.push(row);
                });
            });

            // For any new tag, create a tagged-link entry with that new tag and all links
            newTagIds.forEach(tagId => {
                linkIds.forEach(linkId => {
                    var row = {};
                    row.linkid = linkId,
                    row.tagid = tagId

                    rowsToInsert.push(row);
                });
            });            

            // If there's nothing to insert get out of here
            if (rowsToInsert.length == 0) {
                return;
            }

            return this.bulkInsert(['linkid', 'tagid'], 'tagged-links', rowsToInsert);
        });
    }

    // Delete methods
    deleteTag(tagName) {

        var returnObject = {
            taggedLinksRowsDeleted: 0,
            taggedMessagesRowsDeleted: 0,
            tagsRowsDeleted: 0
        };

        // Find tagId
        return this.db.any('SELECT id FROM "tags" WHERE "name" = $1', [tagName]).then(data => {
            return data[0].id;
        }).then(id => {
            // Delete all tagged-links
            return this.db.result('DELETE FROM "tagged-links" WHERE "tagid" = $1', id).then(result => {
                returnObject.taggedLinksRowsDeleted = result.rowCount;
                
                // Delete all tagged-messages 
                return this.db.result('DELETE FROM "tagged-messages" WHERE "tagid" = $1', id);
            }).then(result => {
                returnObject.taggedMessagesRowsDeleted = result.rowCount;
                
                // Delete tag row
                return this.db.result('DELETE FROM "tags" WHERE "id" = $1', id);
            }).then(result => {
                returnObject.tagsRowsDeleted = result.rowCount;
            });
        }).then(() => {
            return returnObject;
        }).catch(error => {
            return error;
        });
    }

    // Helper methods
    bulkInsert(columnNames, tableName, rows) {
        // Do an efficient insert - https://stackoverflow.com/questions/37300997/multi-row-insert-with-pg-promise
        const cs = new pgp.helpers.ColumnSet(columnNames, {table: tableName});
        const query = pgp.helpers.insert(rows, cs) + 'RETURNING id';
        
        return this.db.map(query, [], a => +a.id).then(newlyInsertedValueIds => {
            return newlyInsertedValueIds;
        });
    }

    insertNewObjectsOnly(arrayOfValues, tableName, columnName) {
        // Find which entries already exist
        return this.db.any('SELECT * FROM "' + tableName + '" WHERE "' + columnName + '" IN ($1:csv)', [arrayOfValues]).then(data => {
            // Create array of inserted/existing values
            let preExistingValues = data.map(d => d[columnName]);
            let preExistingIds = data.map(d => d.id);

            // Check to see which values are brand new
            let valuesToInsert = arrayOfValues.filter(columnValue => !preExistingValues.includes(columnValue))
            
            // If there aren't any new entries to insert, just return the existing ids
            if (valuesToInsert.length == 0) {
                let returnObject = {
                    new: [],
                    old: preExistingIds
                }
                return returnObject;
            }

            // Do an efficient insert - https://stackoverflow.com/questions/37300997/multi-row-insert-with-pg-promise
            const cs = new pgp.helpers.ColumnSet([columnName], {table: tableName});
            var columnValues = [];

            valuesToInsert.forEach(columnValue => {
                let v = {};
                v[columnName] = columnValue;
                columnValues.push(v);
            })

            const query = pgp.helpers.insert(columnValues, cs) + 'RETURNING id';

            return this.db.map(query, [], a => +a.id).then(newlyInsertedValueIds => {
                // Return all ids
                let returnObject = {
                    new: newlyInsertedValueIds,
                    old: preExistingIds
                }
                return returnObject;
            });
        });
    }
};

module.exports = new StorageManager();
