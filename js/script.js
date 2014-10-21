//---------
//Variables
//---------

var mainBox = $(".mainBox");
var body = $("body");
var category;
var questions = {};
var rendered_html;
var points = {
    total: 0
};

var answered = false;

var timer = {};

var categories = {

    animemanga: {
        data_name: 'animemanga',
        title: 'Anime & Manga'
    },

    tvshows: {
        data_name: 'tvshows',
        title: 'TV Shows'
    },

    music: {
        data_name: 'music',
        title: 'Music'
    },

    videogames: {
        data_name: 'videogames',
        title: 'Video Games'
    },

    science: {
        data_name: 'science',
        title: 'Science'
    },

    science: {
        data_name: 'logos',
        title: 'Logos'
    },

    trivia: {
        data_name: 'trivia',
        title: 'Trivia'
    },

    movies: {
        data_name: 'movies',
        title: 'Movies'
    }
};

//---------
//FUNCTIONS
//---------

//Handlebar.js render
function render(tmpl_name, tmpl_data) {

    var tmpl_dir = 'tpl/';
    var tmpl_url = tmpl_dir + tmpl_name + '.html';

    var tmpl_string;
    $.ajax({
        url: tmpl_url,
        method: 'GET',
        async: false,
        success: function(data) {
            tmpl_string = data;
        }
    });

    var source   = tmpl_string;
    var template = Handlebars.compile(source);

    return template(tmpl_data);
}

//Update points
function updatePoints(){
    points.tag.text(points.total);
}

//Byrja timerinn
function startTimer(){

    timer.tag = $(".timer"); //Add to object
    timer.tag.text(timer.seconds); //Display timer

    timer.ID = setInterval(function(){

        timer.seconds--;
        timer.tag.text(timer.seconds); //Update timer

        if (timer.seconds == 0) { //If timout
            timer.tag.css("color","rgba(255,10,10,0.8)");

            clearInterval(timer.ID); //Stop interval
                
            checkAnswer(); //Show answer
            answered = "no"; //Prevent answering afterwards

                
        };
        
    }, 1000);

    
}

//Next question
function nextQuestion(){

    //Hversu margar spurningar eru
    var numberOfQuestions = Object.keys(questions).length-2;

    //Ef þetta var síðasta spurningin
    if(numberOfQuestions == questions.number){
        mainBox.html("");

        rendered_html = render('results', {questions: numberOfQuestions, points: points.total});
        mainBox.html(rendered_html);

        return; //Exit function
    }

    //So that the player can answer
    answered = false;

    //Timer
    timer.seconds = 15;

    //Progress
    questions.progress = (questions.number + 1) + " / " + (numberOfQuestions);

    //Handlebars - Sækja spurninguna
    mainBox.html("");

    rendered_html = render('question', {question: questions[questions.number].question, choices: questions[questions.number].choices, progress: questions.progress, image: questions[questions.number].image});
    mainBox.html(rendered_html);

    //Sækja points taggið og update
    points.tag = $(".points");
    updatePoints();

    //Byrja timer
    startTimer();
}

//Check the answer
function checkAnswer(){
    //If the player answered
    if (answered != false){

        //If correct
        if (answered.text() == questions[questions.number].answer){
            points.total++; //Give points
            $(".choice").each(function(){
                if ($(this).text() == answered.text()){
                    //$(this).css("box-shadow", "inset 0 0 15px 10px rgb(53,162,50)");

                    $(this).css("box-shadow", "none");
                    $(this).css("background-color", "rgb(73,182,70)");
                }
                else{
                    $(this).addClass("disabled");
                }
            });
        }

        //If wrong
        else{
            $(".choice").each(function(){
                if ($(this).text() == answered.text()){
                    //$(this).css("box-shadow", "inset 0 0 15px 10px rgb(299,34,34)");

                    $(this).css("box-shadow", "none");
                    $(this).css("background-color", "rgb(199,14,14)");
                }

                else if($(this).text() == questions[questions.number].answer){
                    //$(this).css("box-shadow", "inset 0 0 15px 10px rgb(53,162,50)");

                    $(this).css("box-shadow", "none");
                    $(this).css("background-color", "rgb(73,182,70)");
                }
                else{
                    $(this).addClass("disabled");
                }
            });
        }

        updatePoints(); //Update points
    }

    //If player didn't answer
    else{
        //alert("time out");
        $(".choice").each(function(){
            if ($(this).text() == questions[questions.number].answer) {
                $(this).css("box-shadow", "inset 0 0 5px 10px rgb(53,162,50)");
            }
            else{
                $(this).addClass("disabled");
            }
        });
    }

    questions.number++;

    setTimeout(function(){
        nextQuestion();
        $('body').scrollTop();
    }, 2500);
}

//Fetch questions and set up the game
function startGame(){

    var post_data = {'category':category}; //Send the category

    $.ajax({
        type: 'POST',
        url: 'includes/getQuestions.php',
        data: post_data,
        dataType: 'json',
        success: function(data){ 
            questions = data;
            //alert(JSON.stringify(data));
            if (questions.result == "success") {
                delete questions.result; //Remove the {result: "success"} from questions

                //Delete meta-data
                for (var i = 0; i < Object.keys(questions).length; i++) {
                    delete questions[i].type;
                    delete questions[i].universe;
                    delete questions[i].gender;

                    if (questions[i].image != null){
                        questions[i].image = "img/questions/" + questions[i].image;
                    }
                };

                //Bæta við hvaða spurning er núverandi og progress overall
                questions.number = 0;
                questions.progress = 0;

                points.total = 0;
                
                nextQuestion();

            }
            //Ef error
            else{
                alert("OH NOES, AN ERROR: " + data);
            }
        } 
    });

}

//Main menu render
function render_MainMenu(){
    mainBox.html("");

    rendered_html = render('mainmenu', {categories: categories});
    mainBox.html(rendered_html);

    $(".slideDownBox").hide();
}

//Leaderboards render
function render_leaderboards(){

    var post_data = {'category':category};

    $.ajax({
        type: 'POST',
        url: 'includes/leaderboards.php',
        data: post_data,
        dataType: 'json',
        success: function(data){ 
            if (data.result == "success") {

                //Ná í category title
                var categoryTitle;

                for(var key in categories){
                    if (categories[key]["data_name"] == category) {
                        categoryTitle = categories[key]["title"];
                    };
                }

                mainBox.html("");

                rendered_html = render('leaderboards', {leaderboard: data, category: categoryTitle});
                mainBox.html(rendered_html);
            }

            else{
                alert(data);
            }
        } 
    });

}

//---------
//Main Menu
//---------

render_MainMenu();


//---------------
//Click functions
//---------------

//Category buttons
body.on("click", ".mainMenuButton", function(){
    $(this).next().slideToggle();
});

//Play! buttons
body.on("click", ".playButton", function(){
    category = $(this).parent().parent().parent().siblings("button").attr("data-category");
    startGame();
});

//Leaderboards buttons
body.on("click", ".leaderboardsButton", function(){
    category = $(this).parent().parent().parent().siblings("button").attr("data-category");
    render_leaderboards();
});

//Choice buttons
body.on("click", ".choice", function(){

    if (answered == false) {
        answered = $(this);

        //Stoppa timer
        clearInterval(timer.ID);

        //answered.css("box-shadow", "inset 0 0 15px 10px rgb(34,229,229)");
        answered.css("background-color", "rgb(34,180,180)");

        if (answered.text() == questions[questions.number].answer) {
            //alert("CORRECT");
        }
        else{
            //alert("WRONG");
        }
  
        //Purely cosmetic. Langar bara hafa þetta fyrir smá dramatic effect.
        setTimeout(function(){
            checkAnswer();
        }, 500);
    }
    
});

//Result
body.on("click", ".resultButton", function(){
    var data = $(this).attr("data-name");

    switch(data){
        case "again":
            startGame();
            break;

        case "menu":
            render_MainMenu();
            break;

        default:
            alert("ERROR");
            break;
    }
});

//Submit to leaderboards
body.on("click", ".submitButton", function(){

    var name = $('.resultInput').val();
            
    var post_data = {'name':name, 'points':points.total, 'playedCategory':category};

    $.post('includes/leaderboards.php', post_data, function(data){
        if (data == "success") {

            render_leaderboards();

        }

        else{
            alert(data);
        }
    });

    
});