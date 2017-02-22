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
    return this.getClasses().then((data)=>{
      return this.rosterLinks;
    })
  }

  getClasses(){
    nightmare
    .goto(`https://bbhosted.cuny.edu/webapps/login/?userid=${this.userName}&password=${this.passWord}`)
    .wait(1000)
    .screenshot("bb6.png")
    .evaluate(
    ()=>
      {
        const classes = document.querySelectorAll('#_4_1termCourses_noterm ul.courseListing a');
        var arr = [];
        for(var i=0; i< classes.length; i++){
          var extract = classes[i].href.match(/\id=(.*)\&url/).pop();
          var className = classes[i].innerHTML;
          arr.push({'id': extract, 'className': className});
        }
        return arr;
      }
)
  .then((links)=> {
    this.rosterLinks = links;
    // console.log(links);
    nightmare
      .wait(1000)
      .then((links)=> {
        this.runNext(this.index);
      });
  });
  }

  runNext(i){
      nightmare
      .goto(`https://bbhosted.cuny.edu/webapps/blackboard/execute/searchRoster?courseId=${this.rosterLinks[i].id}&course_id=${this.rosterLinks[i].id}&action=search&userInfoSearchKeyString=FIRSTNAME&userInfoSearchOperatorString=Contains&userInfoSearchText=`)
      .wait(2000)
      .screenshot(`${this.rosterLinks[i].id}WORKED.png`)
      .evaluate(
        ()=>{
          var students = [];
          var studentRoster = document.querySelectorAll('#listContainer_databody tr');
          console.log(studentRoster);
          for(var z=0; z<studentRoster.length;z++){
            var firstName = studentRoster[z].children[1].innerHTML.replace(/\s/g, '');
            var lastname = studentRoster[z].children[0].children[0].innerHTML.replace(/\<(.*)\>/,"").replace(/\s/g, '');
            var fullName = firstName + " " + lastname;
            students.push(fullName);
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
            // this.returnRoster();
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
