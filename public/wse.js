
$(document).ready(function(){
    setStuffUp();
});

var completed;
var word;

function setStuffUp () {
    completed = 0;
    $("#buttons").hide();
    $("#next").hide();
    $("#done").hide();
    $("#done").click(function(){window.location.replace("/done");});
    $("#button-left").click(function(){doSubmit("#letter-left", word);});
    $("#button-right").click(function(){doSubmit("#letter-right", word);});
    $("#start").click(function(){start();});
    $("#next").click(function(){start();});
}

function start () {
    if (completed < 60) 
        doTest();
    else {
        finish();
    }
}

function doTest () {
    $("#test-text").html('&nbsp;');
    $("#start").hide();
    $("#next").hide();
    getWord(function(w){word = w;runAnimation();});
}

function getWord (callback) {
    $.getJSON("/random",function(data){callback(data);});
}

function runAnimation () {
    $("#test-text").hide();
    var w = word.word.toUpperCase();
    $("#test-text").html(w);
    $("#test-text").show();
    setTimeout(function(){$("#test-text").hide();testFinished();}, 10);
}

function testFinished () {
    setChoices(word.letter.toUpperCase(), word.word.charAt(word.index-1).toUpperCase());
    setTimeout(function(){maskWord(word);$("#test-text").show();}, 1000);
    setTimeout(function(){$("#buttons").fadeIn("fast");}, 1500);
}

function doSubmit (sel) {
    $("#test-text").hide();
    $("#buttons").fadeOut("fast", function(){
        $.post("/test", {'word':word._id, 'choice':$(sel).html()},
            function(){
                completed += 1;
                $("#next").show();
                $("#next").fadeIn("fast");
                $("#next").show();
            });
    });
}

function finish() {
    $("#start").hide();
    $("#next").hide();
    $("#buttons").fadeOut("fast", function(){
        $("#done").show();
    });
}

function setChoices (first, second) {
    var x = Math.random();
    if (x < 0.5) {
        $("#letter-left").html(first);
        $("#letter-right").html(second);
    } else {
        $("#letter-left").html(second);
        $("#letter-right").html(first);
    }
}

function maskWord (word) {
    var letters = word.word.split('');
    for (var i = 0; i < word.word.length; i++) {
        if (i+1 == word.index) {
            letters[i] = "_";
        } else if (word.type == 'letter') {
            letters[i] = " ";
        } else {
            letters[i] = "#";
        }
    }
    $("#test-text").html(letters.join(''));
}


