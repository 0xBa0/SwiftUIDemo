const ERR_Codes = require('./werrorCodes');
const wError = class WError extends Error {
    constructor(code, message) {
      super(message);
     // Ensure the name of this error is the same as the class name
      this.name = this.constructor.name;
     // This clips the constructor invocation from the stack trace.
     // It's not absolutely essential, but it does make the stack trace a little nicer.
     //  @see Node.js reference (bottom)
      Error.captureStackTrace(this, this.constructor);
      this.code = code || ERR_Codes.ERR_INTERNAL;
    }
}
/*
const internalError = class InternalError extends appError {
  constructor (message = "Unexpected error") {
    // Providing default message and overriding status code.
    super(ErrorCodes.InternalErrorCode, message);
  }
}
*/


module.exports = {
  WError : wError,
  internalError : function createInternalError(){
    return new wError(ERR_Codes.ERR_INTERNAL, "系统错误，请联系供应商。")
  },
  emptyEmailError : function createEmptyEmailError(){
    return new wError(ERR_Codes.ERR_EMPTY_EMAIL, "邮箱地址不能为空。")
  },
  invalidEmailError : function createInvalidEmailError(){
    return new wError(ERR_Codes.ERR_INVAIL_EMAIL, "非法的邮箱地址。")
  },
  existsEmailError : function createExistsEmailError(){
    return new wError(ERR_Codes.ERR_EXISTS_EMAIL, "邮箱地址已经被使用。")
  },
  emptyPasswordError : function createEmptyPasswordError(){
    return new wError(ERR_Codes.ERR_EMPTY_PASSWORD, "密码不能为空。")
  },
  invalidPasswordError : function createInvalidPasswordError(){
    return new wError(ERR_Codes.ERR_INVAIL_PASSWORD, "密码长度必须大于6个和小于20个字符。")
  },
  wrongPasswordError : function createWrongPasswordError(){
    return new wError(ERR_Codes.ERR_WRONG_PASSWORD, "密码错误。")
  },
  userNotExistsError : function createUserNotExistsError(){
    return new wError(ERR_Codes.ERR_USER_NOT_EXISTS, "用户不存在。")
  },
  invalidRefreshTokenError : function createInvalidRefreshTokenError(){
    return new wError(ERR_Codes.ERR_INVAILD_REFRESH_TOKEN, "无效的刷新令牌。")
  },
};