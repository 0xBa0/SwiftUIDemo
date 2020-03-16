const Datastore = require('nedb');
const defaultConfig = require('config-lite')(__dirname)
const UserRepository = require('../dal/userRepository');
const UserManager = require('../bll/userManager');

class DI {
    #userManager;
    constructor() {
        this.configDI();
    }
    configDI(dbFilePath, config){
        dbFilePath = dbFilePath || "";
        config = config || defaultConfig;
        let db = new Datastore({ filename: dbFilePath, autoload: true });
        let userRepository = new UserRepository(db);
        this.#userManager = new UserManager(userRepository, config);
    }
    get userManager() {
        return this.#userManager;
    }
}

module.exports = new DI();
/*
var userManager;

function createUserManager(dbPath){
    dbPath = dbPath || "";
    let db = new Datastore({ filename: dbPath, autoload: true });
    let userRepository = new UserRepository(db);
    userManager = new UserManager(userRepository, config);
};

createUserManager();

module.exports = {
    createUserManager: createUserManager,
    userManager: function(){
        return userManager;
    },
}
*/