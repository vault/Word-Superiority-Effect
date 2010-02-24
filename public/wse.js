
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
    $("#button-left").click(function(){doSubmit("#button-left", word);});
    $("#button-right").click(function(){doSubmit("#button-right", word);});
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
    getWord(function(w){word = w;});
    runAnimation();
}

function getWord (callback) {
    $.getJSON("/random",function(data){callback(data);});
}

function runAnimation () {
    $("#test-text").hide();
    $("#test-text").html(word.word.toUpperCase());
    $("#test-text").show();
    setTimeout(function(){$("#test-text").hide();testFinished();}, 20);
}

function testFinished () {
    setChoices(word.letter.toUpperCase(), word.word.charAt(word.index-1).toUpperCase());
    setTimeout(function(){maskWord(word);$("#test-text").show();}, 1000);
    setTimeout(function(){$("#buttons").fadeIn("fast");}, 1500);
}

function doSubmit (sel, word) {
    $("#test-text").hide();
    $("#buttons").fadeOut("fast", function(){
        $.post("/test", {'word':word.id, 'choice':$(sel).html},
            function(){
                completed += 1;
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


