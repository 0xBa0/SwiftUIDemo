'use strict';
module.exports = class User {
   constructor(userId, encryptedPassword, email, phone) {
       this.userId = userId;
       this.encryptedPassword = encryptedPassword;
       this.email = email;
       this.phone = phone;
   }

   display() {
       console.log(this.email + "/" + this.phone);
   }
}
/*
const validator = require('validator');
const uuidv1 = require('uuid/v1');
const sha1 = require('sha1')
const errors = require('../werrors');
module.exports = {
    // 注册一个用户
    createEmailUser: function(email, password) {
        let user = {
            userId: uuidv1(),
            encryptedPassword: sha1(password),
            email: email,
            phone: null
        }
        return user;
    },
    createPhoneUser: function(phone, password) {
        let user = {
            userId: uuidv1(),
            encryptedPassword: sha1(password),
            email: null,
            phone: phone
        }
        return user;
    },
    validateUser: function(user) {
        if (user.email == null && user.phone == null) {
            throw new WUserError('用户必须设置邮箱或电话。')
        } else if (!validator.isEmail(user.email)) {
            throw new WUserError('非法的邮箱地址。')
        } else if (user.encryptedPassword == null || validator.isEmpty(user.encryptedPassword)) {
            throw new WUserError('用户必须设置密码。')
        }
    }
}
*/