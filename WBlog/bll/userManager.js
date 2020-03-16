const validator = require('validator');
const uuidv1 = require('uuid/v1');
const sha1 = require('sha1')
const errors = require('./werrors')
const User = require('./user')
const jwt = require('jsonwebtoken');

class UserManager {
  #userRepository;
  #config;
  constructor(userRepository, config) {
    this.#userRepository = userRepository;
    this.#config = config;
  }
  signupUserByEmail(email, password) {
    if (email == null || validator.isEmpty(email)) {
      return Promise.reject(new errors.emptyEmailError());
    } else if (!validator.isEmail(email)) {
      return Promise.reject(new errors.invalidEmailError());
    } else if (password == null || validator.isEmpty(password)) {
      return Promise.reject(new errors.emptyPasswordError());
    } else if (!validator.isLength(password, {min:6, max: 20})) {
      return Promise.reject(new errors.invalidPasswordError());
    } else {
      let user = new User(uuidv1(), sha1(password), email, null);
      return this.#userRepository.createUser(user);
    }
  }
  signinByEmail(email, password) {
    let config = this.#config;
    return this.getUserByEmail(email).then(function(user) {
      if(user == null) {
        return Promise.reject(errors.userNotExistsError());
      } else if(sha1(password) == user.encryptedPassword) {
        var accessToken = jwt.sign({ userId: user.userId }, config.jwtSecret,  {expiresIn: config.accessTokenExpiresIn});
        var refreshToken = jwt.sign({ userId: user.userId }, config.jwtSecret,  {expiresIn: config.refreshTokenExpiresIn});
        let sigininfo = {
                          userId: user.userId, 
                          accessToken: accessToken, 
                          refreshToken:refreshToken
                        };
        return Promise.resolve(sigininfo);
      } else {
        return Promise.reject(errors.wrongPasswordError());
      }
    });
  }
  refreshToken(refreshToken) {
    let config = this.#config;
    try {
      let playload = jwt.verify(refreshToken, config.jwtSecret);
      let userId = playload.userId;
      var accessToken = jwt.sign({ userId: userId }, config.jwtSecret,  {expiresIn: config.accessTokenExpiresIn});
      var refreshToken = jwt.sign({ userId: userId }, config.jwtSecret,  {expiresIn: config.refreshTokenExpiresIn});
      let sigininfo = {
                          userId: userId, 
                          accessToken: accessToken, 
                          refreshToken:refreshToken
                        };
      return Promise.resolve(sigininfo);
    } catch(err) {
      return Promise.reject(errors.invalidRefreshTokenError());
    }
  }
  getUserByEmail(email) {
    if (email == null || validator.isEmpty(email)) {
      return Promise.reject(new errors.emptyEmailError());
    } else if (!validator.isEmail(email)) {
      return Promise.reject(new errors.invalidEmailError());
    } else {
      return this.#userRepository.getUserByEmail(email);
    }
  }
}
module.exports = UserManager
