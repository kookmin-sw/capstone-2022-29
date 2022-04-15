const mongoose = require('mongoose');

const NewsSchema = new mongoose.Schema({
    journal: { type: String, required: true },
    date: { type: String, required: true },
    title: { type: String, required : true },
    url: { type: String, required:true },
    content: { type: String, required : true },
}, { collection: "news" });

const UserSchema = new mongoose.Schema({
    access_token: { type: String, required: true },
    nickname: { type: String, required : true },
    profile: { type: String, required : true },
    // email: { type: String },
}, { collection: "users" });

const BookmarkSchema = new mongoose.Schema({
    user_id: { type: String, required : true },
    query: { type: String, required : true },
    count: { type: Number, required: true },
}, { collection: "bookmarks" });

const News = mongoose.model("News", NewsSchema);
const User = mongoose.model("User", UserSchema);
const Bookmark = mongoose.model("Bookmark", BookmarkSchema);

module.exports = {
    News,
    User,
    Bookmark,
};