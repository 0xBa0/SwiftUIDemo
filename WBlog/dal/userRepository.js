const errors = require('../bll/werrors')
const User = require('../bll/user')
// const Datastore = require('nedb')

class UserRepository {
    #db;
    constructor(db) {
        this.#db = db
        this.#db.ensureIndex({ fieldName: 'userId', unique: true, sparse: false }, function (err) {
        });
        this.#db.ensureIndex({ fieldName: 'email', unique: true, sparse: false }, function (err) {
        });
    }
    createUser(user) {
        let db = this.#db;
        return new Promise(function(resolve, reject) {
            db.insert(user, function (err, newDoc) {  
                if(err != null){
                    if(err.errorType == 'uniqueViolated') {
                        reject(errors.existsEmailError());
                    } else {
                        reject(err);
                    }
                } else {
                    resolve(newDoc.userId) ;
                }
            }); 
        });
    }
    getUserByEmail(email) {
        let db = this.#db;
        return new Promise(function(resolve, reject) {
            db.findOne({ email: email }, function (err, doc) {
                if(err != null){
                    reject(err);
                } else {
                    let user = null;
                    if(doc != null) {
                        user = new User(doc.userId, doc.encryptedPassword, doc.email, doc.phone);
                    }
                    resolve(user);
                }
            });
        });
    }
}
module.exports = UserRepository
/*
const Datastore = require('nedb')
const errors = require('../bll/werrors')
const User = require('../bll/user')

class UserRepository {
    constructor() {
        this.db = new Datastore({ filename: 'data/datafile', autoload: true });
        this.db.ensureIndex({ fieldName: 'userId', unique: true, sparse: false }, function (err) {
        });
        this.db.ensureIndex({ fieldName: 'email', unique: true, sparse: false }, function (err) {
        });
    }
    useMemoryDB() {
        this.db = new Datastore();
        this.db.ensureIndex({ fieldName: 'userId', unique: true, sparse: false }, function (err) {
        });
        this.db.ensureIndex({ fieldName: 'email', unique: true, sparse: false }, function (err) {
        });
    }
    createUser(user) {
        let db = this.db;
        return new Promise(function(resolve, reject) {
            db.insert(user, function (err, newDoc) {  
                if(err != null){
                    if(err.errorType == 'uniqueViolated') {
                        reject(errors.existsEmailError());
                    } else {
                        reject(err);
                    }
                } else {
                    resolve(newDoc.userId) ;
                }
            }); 
        });
    }
    getUserByEmail(email) {
        let db = this.db;
        return new Promise(function(resolve, reject) {
            db.findOne({ email: email }, function (err, doc) {
                if(err != null){
                    reject(err);
                } else {
                    let user = null;
                    if(doc != null) {
                        user = new User(doc.userId, doc.encryptedPassword, doc.email, doc.phone);
                    }
                    resolve(user);
                }
            });
        });
    }
}

module.exports = new UserRepository();
*/