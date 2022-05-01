const models = require("../models");

const Bookmark = models.Bookmark;

const postBookmark = async (req, res) => { // -> 사용자가 한번도 bookmark를 등록 X
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

const getBookmark = async (req, res) => { // -> 사용자의 bookmark를 조회할 때
    const regex = new RegExp(req.query.user_id);
    await Bookmark.find(
        {'user_id': {'$regex': regex}}, 
        function(err, bookmark){
            if(err) return res.status(500).json({ error: err });
            if(!bookmark) return res.status(404).json({ error: '해당 북마크의 뉴스가 존재하지 않습니다.' });
            res.json(bookmark);
        }
    ).clone().catch(function(err){console.log(err)});
};

const updateBookmark = async (req, res) => { // -> 사용자가 bookmark를 등록한 적이 있으면 update
    const regexUID = new RegExp(req.query.user_id);
    if(req.query.news_id == undefined){ 
        await Bookmark.findOneAndUpdate( // 사용자의 기존 bookmark에 새로운 bookmark 추가
            {'user_id': {$regex: regexUID}}, 
            {$addToSet: 
                {'bookmark': 
                    {
                        'news_id': req.body.bookmark.news_id, 
                        'query': req.body.bookmark.query, 
                        'topic': req.body.bookmark.topic
                    }
                }
            },
            function(err){
                if(err){
                    console.error(err);
                    res.json({ message : 'fail' });
                    return;
                }
                res.json({ message : 'success' });
            }
        ).catch(function(err){console.log(err)});
    }
    else{
        const regexNID = new RegExp(req.query.news_id);
        await Bookmark.findOneAndUpdate( // 사용자의 기존 bookmark에서 원하는 news_id bookmark 삭제
            {'user_id': {$regex: regexUID}},
            // {$pull: {'bookmark': {$elemMatch: {'news_id': {$regex: regexNID}}}}},
            {$pull: {'bookmark': {'news_id': {$regex: regexNID}}}},
            {new: true},
            function(err, bookmark){
                if(err) return res.status(500).json({ error: err });
                if(!bookmark) return res.status(404).json({ error: '해당 북마크의 뉴스가 존재하지 않습니다.' });
                res.json(bookmark);
            }
        ).catch(function(err){console.log(err)});
    }
}

module.exports = {
    postBookmark,
    getBookmark,
    updateBookmark,
};