const models = require("../models");

const Topic = models.Topic;

const postTopic = async (req, res) => {
    const newTopic = new Topic(req.body);
    await newTopic.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
        }
        res.json({ message : 'success' });
    });
};

const getTopic = async (req, res) => {
    const regexQuery = new RegExp(req.query.query); // 검색어
    const page = Number(req.query.page || 1);
    const perPage = Number(req.query.perPage || 10);
    await Topic.find(
        {
            'query': {'$regex': regexQuery},
            'topicNum': {'$elemMatch': {'num': req.query.num}}
        }
        .skip(perPage * (page - 1))
        .limit(perPage)
    ).then(topic => {
        if(!topic) res.status(404).json({ error: '해당 쿼리의 토픽이 존재하지 않습니다.' });
        else res.json(topic);
    }).catch(err => res.status(500).json({ error: err }));
};

module.exports = {
    postTopic,
    getTopic,
}