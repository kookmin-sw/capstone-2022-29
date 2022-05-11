const models = require("../models");

const User = models.User;

const postUserInfo = async (req, res) => {
    const newUser = new User(req.body);
    await newUser.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
        }
        res.json({ message : 'success' });
    });
};

const getUserInfo = async (req, res) => {
    // const regex = new RegExp(req.query.nickname);
    await User.find(
        {'nickname':{$eq:req.query.nickname}},
    ).then(user => {
        if(!user) res.status(404).json({ error: '해당 회원이 존재하지 않습니다.' });
        else res.json(user);
    }).catch(err => res.status(500).json({ error: err }));
};

const updateUser = async (req, res) => {
    await User.updateOne(
        {nickname: req.query.nickname},
        {$set: req.body},
    ).then(res.json({ message : 'success' })).catch(err => console.log(err));
}

module.exports = {
    postUserInfo,
    getUserInfo,
    updateUser,
}