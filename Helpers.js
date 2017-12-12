const Constants = require('./Constants.js')

class Helpers {
    constructor() {

    }

    extract(regex, text) {
        // found on stackoverflow
        var foundItems = text.match(regex);
        foundItems = foundItems ? foundItems : [];
        
        foundItems.forEach(function(item, index) {
            foundItems[index] = item.trim();
        });
        
        return foundItems;
    }
    
    extractLinks(messageText) {
        let urlRegex = Constants.URLREGEX();
        return this.extract(urlRegex, messageText);
    }
    
    extractTags(messageText) {
        let tagRegex = Constants.TAGREGEX();
        return this.extract(tagRegex, messageText);
    }
}

module.exports = new Helpers();