const models = require("../models");

const News = models.News;

const postNews = async (req, res) => {
    const newNews = new News(req.body);
    await newNews.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getNews = async (req, res) => {
    const regex = new RegExp(req.query.query);
    await News.find({'$or': [ {'title':{'$regex':regex}},{'content':{'$regex':regex}} ]}, function(err, news){
        if(err) return res.status(500).json({ error: err });
        if(!news) return res.status(404).json({ error: '해당 뉴스가 존재하지 않습니다.' });
        res.json(news);
    }).clone().catch(function(err){console.log(err)});
};

// 전체 뉴스 정보 (title, content, date, url)
const getAllNews = async (req, res) => {
    await News.find(function(err, news){
        if(err) return res.status(500).json({ error: err });
        if(!news) return res.status(404).json({ error: '뉴스가 존재하지 않습니다.' });
        res.json(news);
    }).clone().catch(function(err){console.log(err)});
};

module.exports = {
    // news
    postNews,
    getNews,
    getAllNews,
}