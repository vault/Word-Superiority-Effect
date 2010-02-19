
$(document).ready(function(){
    setStuffUp();
});

var completed;

function setStuffUp () {
    completed = 0;
    $("#buttons").hide();
    $("#next").hide();
    $("#done").hide();
    $("#start").click(function(){start("#start");});
    $("#next").click(function(){start("#next");});
}

function start (element) {
    for (var i = 0; i < 60; i++) {
        doTest();
    }
    finish();
}

function doTest () {
    $("#test-text").html('&nbsp;');
    getWord(function(word){runAnimation(word);});
}

function getWord (callback) {
    $.getJSON("/random",function(data){callback(data);});
}

function runAnimation (word) {
    $("#test-text").hide();
    $("#test-text").html(word.word.toUpperCase());
    $("#test-text").show();
    setTimeout(function(){$("#test-text").hide();testFinished(word);}, 20);
}

function testFinished (word) {
    setChoices(word.letter.toUpperCase(), word.word.charAt(word.index-1).toUpperCase());
    setTimeout(function(){maskWord(word);$("#test-text").show();}, 1000);
    setTimeout(function(){$("#buttons").fadeIn("fast");}, 1500);
    $("#button-left").click(function(){doSubmit("#button-left", word);});
    $("#button-right").click(function(){doSubmit("#button-right", word);});
}

function doSubmit (sel, word) {
    completed += 1
    $("#test-text").hide();
    $("#buttons").fadeOut("fast", function(){
        $.post("/test", {'word':word.id, 'choice':$(sel).html,
                'type':word.type}, function(){
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
        } else {
            letters[i] = "#";
        }
    }
    $("#test-text").html(letters.join(''));
}

function toggleElements(cur, next, callback) {
    $(cur).fadeOut("fast", function(){$(next).fadeIn("fast", callback());});
}

