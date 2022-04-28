const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    access_token: { type: String, required: true },
    nickname: { type: String, required : true },
    profile: { type: String, required : true },
    // email: { type: String },
}, { collection: "users" });

const NewsSchema = new mongoose.Schema({
    journal: { type: String, required: true },
    date: { type: String, required: true },
    title: { type: String, required : true },
    url: { type: String, required:true },
    content: { type: String, required : true },
    summary: { type: String, required: true },
}, { collection: "news" });

const BubbleSchema = new mongoose.Schema({
    user_id: { type: String, required: true },
    // query: { type: String, required : true },
    // count: { type: Number, required: true }, // 검색어 -> 토픽 -> 뉴스 기사 클릭하면 count+1
    bubble: {type: Map, default: { query: '', count: 0 }, required: true, },
}, { collection: "bubbles" });

const TopicSchema = new mongoose.Schema({
    date: { type: Date, required: true },
    query: { type: String, required : true },
    topic: { type: Array, required: true },
}, { collection: "topics" });

const BookmarkSchema = new mongoose.Schema({
    user_id: { type: Schema.Types.ObjectId, required : true },
    news_id: { type: Schema.Types.ObjectId, required : true },
    query: { type: String, required : true },
    topic: { type: String, required: true },
}, { collection: "bookmarks" });

const User = mongoose.model("User", UserSchema);
const News = mongoose.model("News", NewsSchema);
const Bubble = mongoose.model("Bubble", BubbleSchema);
const Topic = mongoose.model("Topic", TopicSchema);
const Bookmark = mongoose.model("Bookmark", BookmarkSchema);

module.exports = {
    User,
    News,
    Bubble,
    Topic,
    Bookmark,
};