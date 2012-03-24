
var interval;
var statements = 0;
var prevData = {}


function setGameLog(log) {
  $log = $('.log').html("<p>" + log.join("</p><p>") + "</p>")
}

function imgElementFor(imgName) {
  img = $('img .card.' + imgName)
  if (img.length == 0) {
    img = $("<img src='/assets/cards/" + imgName + ".png' class='card " + imgName + "'></img>")
    img.appendTo($('.img-cache'));
  }
  return img;
}

function imageFor(n,classes) {
  return "<img src='/assets/cards/" + n + ".png' class='card " + (classes || "") + "'></img>"
}

function setPlayerImages($pair,form,base) {
  $pair.show();
  $pair.find('img').detach().appendTo('.img-cache')
  // This should, instead, see if we have an element for that base
  imgElementFor(form).detach().appendTo($pair)
  imgElementFor(base).detach().appendTo($pair)
}

// Given the data about a player, and their name, fill in the player data
function setPlayer(name,data) {
  var location = $('.' + name)
  //Accumlate the html for the player.
  //TODO make divs with the class name for each in data.
  var val = ""
  val += "<p>Name: " + name + "</p>"
  val += "<p>Life: " + data.life + "</p>"

  val += "<p>Forms:"
  for (var i = 0; i < data.forms.length; i+=1) {
    val = val + "<span class='hoverable'>" + data.forms[i] + " " + imageFor(data.forms[i], 'hover') + "</span>"
  }
  val += "</p>"

  val += "<p>Bases:"
  for (var i = 0; i < data.bases.length; i+=1) {
    val = val + "<span class='hoverable'>" + data.bases[i] + " " + imageFor(data.bases[i],'hover') + "</span>"
  }
  val += "</p>"

  val += "<p>Current Power: " + data.power + "</p>"
  val += "<p>Current Range: " + data.range + "</p>"
  val += "<p>Current Priority: " + data.priority + "</p>"
  val += "<p>Stun Guard: " + data.stun_guard + "</p>"
  val += "<p>Soak: " + data.soak + "</p>"
  val += "<p>Stun immunity: " + data.stun_immunity + "</p>"
  location.find('.character').html(val)

  //Set the player images
  if (data.base) {
    setPlayerImages(location.find('.pair'), data.form, data.base)
  } else {
    location.find('.pair').hide();
  }
  
  //TODO make this actually display their character image.
  $('.board .position' + data.position).text(name)
}
function clearChoices() {
  $('.choices').html('');
}

// Depending on the query, ask the player for input in different ways.
// 1) Attackpairs should display both types of cards, and wait until you've clicked on one of each.
// 2) Bases just display your current bases, and wait until you click on one.
// 3) Tokens display token images, and a "pass" token. Wait until you click on one.
// On all other cases, just display the text.
function setChoices(query, choices, pl) {
  if (query == 'attack_pairs') {
    var bases = {}
    var forms = {};
    for (var i = 0; i < choices.length; i++) {
      var l = choices[i].split(':');
      bases[l[1]] = true;
      forms[l[0]] = true;
    }
    setAttackPairsQuery(bases,forms,pl);
  } else if (false) {//if (query == 'bases' || query == 'tokens') {

  } else {
    var $choices = $('.choices')
    var val = ''
    for(var i = 0; i < choices.length; i++) {
      val += "<a href='#'>" + choices[i] + "</a> " 
    }
    $choices.html(val);
    $('.choices a').click(function(){
      inp($(this).text());
    })
  }
}
function hoverImageFor(imageName) {
  return ("<span class='hoverable'>" + imageFor(imageName,'select-card') + 
  "<span class='hover'>" + imageFor(imageName) + "</span></span>")
}
function hoverText(text) {
  return "<span class='hoverable'>" + text + " " + imageFor(text,'hover') +"</span>"
}

function setAttackPairsQuery(bases,forms,player) {
  var $choices = $('.choices')
  $choices.html('<div class="forms"></div><div class="bases"></div>');
  $bases = $choices.find('.bases')
  $forms = $choices.find('.forms')
  for (var base in bases) {
    $bases.append(hoverText(base))
  }
  for (var form in forms) {
    $forms.append(hoverText(form))
  }
  // Closure!
  (function() {
    var selectedBase = undefined;
    var selectedForm = undefined;
    var trigger = function() {
      if (selectedBase && selectedForm) {
        console.log("Base is ",selectedBase," Form is ",selectedForm)
        inp(selectedForm + ":" + selectedBase);
      }
    }
    console.log("Hello", $bases, $forms)
    $bases.on('click', 'span', function() {
      $bases.find('span').css('text-decoration','none')
      $(this).css('text-decoration','underline')
      selectedBase = $.trim($(this).text());
      trigger();
    })
    $forms.on('click', 'span', function() {
      $forms.find('span').css('text-decoration','none')
      $(this).css('text-decoration','underline')
      selectedForm = $.trim($(this).text());
      trigger();
    })
  })()
  
}








function loadData(data) {
  if (data.number != prevData.number){
    console.log("Data number is ", data.number, "and previously it was ", prevData.number)
    $('.board .space').text('')
    if (data.p1) {
      setPlayer('p1',data.p1)
      setPlayer('p2',data.p2)
    }
    setGameLog(data.log);
    if (data.pending_input) {
      console.log("Data pending?")
      setChoices(data.query, data.pending_input);
    } else {
      clearChoices();
    }
    if (data.winner) {
      console.log("Finished game.")
      $('.' + data.winner).addClass('winner').prepend("<h2>Winner!<h2>")
      $('.player:not(.winner)').prepend("<h2>Loser!<h2>")
      clearInterval(interval);
    } 
    prevData = data
  }
}
var refreshStatus;

function inp(x) {
  console.log("POSTING...", x);
  $.post(''
  , {input: x}
  , function(data){ 
    if (data.success) {
      loadData(data.game);
    }
  })
}
function init(challenge_id){
  refreshStatus = function() {
    $.get(challenge_id + '.json', loadData)
  }
  console.log("INIT")
  interval = setInterval('refreshStatus();', 1000);
  refreshStatus();
}