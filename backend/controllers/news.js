const { ObjectID } = require("bson");
const models = require("../models");

const News = models.News;

const postNews = async (req, res) => {
    const newNews = new News(req.body);
    await newNews.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
        }
        res.json({ message : 'success' });
    });
};

const getNews = async (req, res) => {
    const regexQuery = new RegExp(req.query.query);
    if(req.query.news_id == undefined) {
        const page = Number(req.query.page || 1);
        const perPage = Number(req.query.perPage || 10);
        await News.find(
            {'$or': [ {'title': {'$regex':regexQuery}},{'content': {'$regex':regexQuery}} ]}, 
        )
        // .sort({ 'date': -1 })
        .skip(perPage * (page - 1))
        .limit(perPage)
        .then(news => {
            if(!news) res.status(404).json({ error: '해당 뉴스가 존재하지 않습니다.' });
            else res.json(news);
        }).catch(err => res.status(500).json({ error: err }));
    }
    else {
        await News.find(
            {_id: ObjectID(req.query.news_id)},
        ).then(news => {
            if(!news) res.status(404).json({ error: '해당 뉴스가 존재하지 않습니다.' });
            else res.json(news);
        }).catch(err => res.status(500).json({ error: err }));
    }
};

module.exports = {
    postNews,
    getNews,
}