
$(document).ready(function(){
    setStuffUp();
});

var participantID;
var completed;

function setStuffUp () {
    ensureLogin();
    completed = 0;
    $("#buttons").hide();
    $("#next").hide();
    $("#done").hide();
    $("#start").click(function(){start("#start");});
    $("#next").click(function(){start("#next");});
}

function ensureLogin () {
    participantID = $.cookie('partID');
    if (!participantID) {
        window.location("/register");
    }
}

function start (element) {
    $(element).fadeOut("fast", completed < 60 ? doTest : finish);
}

function doTest () {
    $("#test-text").html('&nbsp;');
    getWord(function(word){runAnimation(word);});
}

function getWord (callback) {
    $.getJSON("/words/random/unseen",{"partID":participantID},function(data){callback(data);});
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
        $.post("test/"+participantID, {'word':word.id, 
                'partID':participantID}, function(){
                    $("#next").fadeIn("fast");
                });
        });
}

function finish() {

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

