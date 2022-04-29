const models = require("../models");

const Bookmark = models.Bookmark;

const postBookmark = async (req, res) => { // 처음에는 post
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

// 사용자가 북마크한 쿼리와 개수
const getBookmark = async (req, res) => {
    const regex = new RegExp(req.query.user_id);
    await Bookmark.find({'user_id':{'$regex':regex}}, function(err, bookmark){
        if(err) return res.status(500).json({ error: err });
        if(!bookmark) return res.status(404).json({ error: '해당 북마크의 뉴스가 존재하지 않습니다.' });
        res.json(bookmark);
    }).clone().catch(function(err){console.log(err)});
};

const updateBookmark = async (req, res) => { // find -> 있으면 put
    await Bookmark.updateOne(
        {query: req.query.query},
        {$set: req.body},
    ).clone().catch(function(err){console.log(err)});
}

module.exports = {
    // bookmark
    postBookmark,
    getBookmark,
    updateBookmark,
};