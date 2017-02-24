// const Scraper = require('../models/class_info_scraper');
import Scraper from '../models/class_info_scraper'
const userController = {};

userController.post = (req, res) => {
  const { username, password } = req.body;
  console.log(req.body);
  var scraper = new Scraper(username, password);
  console.log(scraper.returnRoster());
  scraper.returnRoster().then((classData) => {
    res.status(200).json({
      success: true,
      data: scraper.rosterLinks,
    });
  }).catch((err) => {
    res.status(500).json({
      message: err,
    });
  });

};

export default userController;
