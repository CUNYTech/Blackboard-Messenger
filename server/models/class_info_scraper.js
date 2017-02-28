"use strict";
var Nightmare = require('nightmare');
var nightmare = new Nightmare();
var async = require("async");

 class ClassInfoScraper{
  constructor(userName, passWord){
    this.userName = userName;
    this.passWord = passWord;
    this.rosterLinks = [];
    this.index = 0;
  }

  returnRoster(){
    this.getClasses();
    return new Promise((resolve, reject)=>{
      //hacksh but it works, will wait 20 secs, hopefully enough time to be done scraping.
    setTimeout(()=>{
        resolve(this.rosterLinks);
    }, 20000);
});
  }

  getClasses(){
    nightmare
    .goto(`https://bbhosted.cuny.edu/webapps/login/?userid=${this.userName}&password=${this.passWord}`)
    .wait(1000)
    .screenshot("bb6.png")
    .evaluate(
    ()=>
      {
        const classes = document.querySelectorAll('#_4_1termCourses_noterm ul.coursefakeclass a');
        const studentName = document.querySelector("#global-nav-link").innerHTML.match(/\>(.*)\<span id=/).pop();
        var arr = [];
        for(var i=0; i< classes.length; i++){
          if(classes[i].href.match(/\id=(.*)\&url/)){
            var extract = classes[i].href.match(/\id=(.*)\&url/).pop();
            var className = classes[i].innerHTML;
            arr.push({'class_id': extract, 'studentName': studentName,'className': className});
          }
        }
        return arr;
      }
)
  .then((links)=> {
    this.rosterLinks = links;
    console.log(links);
    nightmare
      .wait(1000)
      .then((links)=> {
        this.runNext(this.index);
      });
  });
  }
// `https://bbhosted.cuny.edu/webapps/blackboard/execute/searchRoster?courseId=${this.rosterLinks[i].id}&course_id=${this.rosterLinks[i].id}&action=search&userInfoSearchKeyString=FIRSTNAME&userInfoSearchOperatorString=Contains&userInfoSearchText=`
  runNext(i){
      nightmare
      .goto(`https://bbhosted.cuny.edu/webapps/blackboard/execute/displayEmail?navItem=email_select_students&course_id=${this.rosterLinks[i].class_id}`)
      .wait(1000)
      .screenshot(`${this.rosterLinks[i].class_id}WORKED.png`)
      .evaluate(
        ()=>{
          var students = [];
          // var studentRoster = document.querySelectorAll('#listContainer_databody tr');
          var studentRoster = document.querySelectorAll('#USERS_AVAIL  option');
          console.log(studentRoster);
          // for(var z=0; z<studentRoster.length;z++){
          //   var firstName = studentRoster[z].children[1].innerHTML.replace(/\s/g, '');
          //   var lastname = studentRoster[z].children[0].children[0].innerHTML.replace(/\<(.*)\>/,"").replace(/\s/g, '');
          //   var fullName = firstName + " " + lastname;
          //   students.push(fullName);
          // }
          for(var z=0; z<studentRoster.length; z++){
            var name = studentRoster[z].innerHTML;
            students.push(name);
          }
            return students;
        }
        )
      .then((students)=>{
        this.rosterLinks[this.index]['students'] = students;
        this.index++;

        // only run next search when we successfully get here
        if(this.index < this.rosterLinks.length){
            this.runNext(this.index);
        } else {
            console.log(this.rosterLinks);
            console.log("End");
            nightmare.halt();
        }
     })
      .catch((error)=> {
        console.error('Search failed:', error);
      });
  }

}
export default ClassInfoScraper;
// var scrapper = new ClassInfoScraper('isuru0123','509973006');
// scrapper.getClasses();
// {"username":"mmalek1421","password": "Gleo1421"}
// "start": "nodemon bin/dev"
