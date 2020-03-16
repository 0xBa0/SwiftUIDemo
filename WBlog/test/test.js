/*
const should = require('chai').should();
describe('Given a Object', function() {
    beforeEach(function() {
      
    });
    describe('When test', function() {
      it('Then result', async function() {
        let promise = new Promise(function(resolve, reject) {
            let obj = {code: 0, message:"msg", data: {accessToken: "accessToken", refreshToken:"refreshToken"}};
            resolve(obj);
        });
           
        let testObj = await promise;
         testObj.should.have.property('code').to.be.equal(0)
         testObj.data.should.have.property('accessToken').not.be.null.and.empty;
         testObj.data.should.have.property('refreshToken').not.be.null.and.empty;
      });
    });
});
*/