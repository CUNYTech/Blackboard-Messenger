// const Scraper = require('../models/class_info_scraper');
import Scraper from '../models/class_info_scraper'
const userController = {};

userController.post = (req, res) => {
  const { username, password } = req.body;
  console.log(req.body);
  var scraper = new Scraper(username, password);
  // var p1 = new Promise(
  //     // The resolver function is called with the ability to resolve or
  //     // reject the promise
  //     (resolve, reject)=>{
  //         var scraper = new Scraper('isuru0123', '509973006');
  //         resolve(scraper.getClasses());
  //     }
  // );

  scraper.returnRoster().then((classData) => {
    res.status(200).json({
      success: true,
      data: classData,
    });
  }).catch((err) => {
    res.status(500).json({
      message: err,
    });
  });

};

export default userController;


// var p1 = new Promise(
//     // The resolver function is called with the ability to resolve or
//     // reject the promise
//     function(resolve, reject) {
//         var scraper = new Scraper('isuru0123', '509973006');
//         scraper.getClasses();
//     }
// );
