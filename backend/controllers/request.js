const models = require("../models");

const Request = models.Request;

const postRequest = async (req, res) => {
    const request = new Request(req.body);
    await request.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
        }
        res.json({ message : 'success' });
    });
};

const getRequest = async (req, res) => {
    await Request.find()
    .then(request => {
        if(!request) res.status(404).json({ error: '토픽과 관련있는 요청이 존재하지 않습니다.' });
        else res.json(request);
    }).catch(err => res.status(500).json({ error: err }));
};

module.exports = {
    postRequest,
    getRequest,
}