const router = require("express").Router();

// controllers
const user = require("./controllers/user");
const news = require("./controllers/news");
const bubble = require("./controllers/bubble");
const topic = require("./controllers/topic");
const bookmark = require("./controllers/bookmark");
const keyword = require("./controllers/keyword");

// user
router.post("/users", user.postUserInfo);
router.get("/users", user.getUserInfo);
router.put("/users", user.updateUser);

// news
router.post("/news", news.postNews);
router.get("/news", news.getNews);

// bubble
router.post("/bubbles", bubble.postBubble);
router.get("/bubbles", bubble.getBubble);
router.put("/bubbles", bubble.updateBubble);

// topic
router.post("/topics", topic.postTopic);
router.get("/topics", topic.getTopic);

// bookmark
router.post("/bookmarks", bookmark.postBookmark);
router.get("/bookmarks", bookmark.getBookmark);
router.put("/bookmarks", bookmark.updateBookmark);

// keyword
router.post("/keywords", keyword.postKeyword);
router.get("/keywords", keyword.getKeyword);
router.put("/keywords", keyword.updateKeyword);

module.exports = router;