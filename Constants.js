const urlRegex = /(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g;
const tagRegex = /\^([^\s][^0-9][a-z]*)/g;

class Constants {
    constructor() {

    }

    URLREGEX() {
        return urlRegex;
    }

    TAGREGEX(){
        return tagRegex;
    }
}

module.exports = new Constants();