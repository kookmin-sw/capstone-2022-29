const models = require("./models");

const User = models.User;

const postUserInfo = async (req, res) => {
    const newUser = new User(req.body);
    await newUser.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getUserInfo = async (req, res) => {
    const regex = new RegExp(req.query.accessToken);
    await User.find({'access_token':{'$regex':regex}}, function(err, user){
            if(err) return res.status(500).json({ error: err });
            if(!user) return res.status(404).json({ error: '해당 회원이 존재하지 않습니다.' });
            res.json(user);
    }).clone().catch(function(err){console.log(err)});
};

const findUser = async (req, res) => {
    const regex = new RegExp(req.query.nickname);
    await User.find({'nickname':{'$regex':regex}}, function(err, user){
            if(err) return res.status(500).json({ error: err });
            if(!user) return res.status(404).json({ error: '해당 회원이 존재하지 않습니다.' });
            res.json(user);
    }).clone().catch(function(err){console.log(err)});
};

const updateUser = async (req, res) => {
    // const newUser = new User(req.body);
    await User.updateOne(
        {nickname: req.query.nickname},
        {$set: req.body},
    ).clone().catch(function(err){console.log(err)});
}

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
// const getAllNews = async (req, res) => {
//     await News.find(function(err, news){
//         if(err) return res.status(500).json({ error: err });
//         if(!news) return res.status(404).json({ error: '해당 뉴스가 존재하지 않습니다.' });
//         res.json(news);
//     }).clone().catch(function(err){console.log(err)});
// };

const Bubble = models.Bubble;

const postBubble = async (req, res) => {
    const newBubble = new Bubble(req.body);
    print(req.body);
    await newBubble.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getBubble = async (req, res) => {
    const regex = new RegExp(req.query.user_id);
    await Bubble.find({'user_id':{'$regex':regex}}, function(err, bookmark){
        if(err) return res.status(500).json({ error: err });
        if(!bookmark) return res.status(404).json({ error: '해당 회원의 버블이 존재하지 않습니다.' });
        res.json(bookmark);
    }).clone().catch(function(err){console.log(err)});
};

const Bookmark = models.Bookmark;

const postBookmark = async (req, res) => {
    const newBookmark = new Bookmark(req.body);
    await newBookmark.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

// // 사용자가 북마크한 쿼리와 개수
const getBookmark = async (req, res) => {
    const regex = new RegExp(req.query.user_id);
    await Bookmark.find({'user_id':{'$regex':regex}}, function(err, bookmark){
        if(err) return res.status(500).json({ error: err });
        if(!bookmark) return res.status(404).json({ error: '해당 북마크의 뉴스가 존재하지 않습니다.' });
        res.json(bookmark);
    }).clone().catch(function(err){console.log(err)});
};

const updateBookmark = async (req, res) => {
    await Bookmark.updateOne(
        {query: req.query.query},
        {$set: req.body},
    ).clone().catch(function(err){console.log(err)});
}

module.exports = {
    // user
    postUserInfo,
    getUserInfo,
    findUser,
    updateUser,
    // news
    postNews,
    getNews,
    // bubble
    postBubble,
    getBubble,
    // bookmark
    postBookmark,
    getBookmark,
    updateBookmark,
};