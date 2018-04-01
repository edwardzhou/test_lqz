// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import {socket, channel} from "./socket"
// import jquery from "./jquery.min"
import Swiper from "./swiper.min"
// window.jQuery = jquery
// window.$ = jquery
// window.Swiper
// import {connect_server} from "./auction"

$(function(){
  var swiper = new Swiper('.swiper7', {
    pagination: '.swiper-pagination',
    paginationClickable: true,
    autoplay: 2500
  });
})

function submit_bid(increase) {
  bid_msg = window.bid_msg
  channel.push("new_bid", {
    token_id: bid_msg.next_token_id, 
    bid_base: bid_msg.top_bid.bid,
    increase: increase
  })  
}

$(function() {
  $(".offer200").on("click", () => {
    let increase = $(".offer200").data("increase")
    submit_bid(increase)
  });
  
  
  $(".offer500").on("click", () => {
    let increase = $(".offer500").data("increase")
    submit_bid(increase)
  });
  
  
  $(".offer1000").on("click", () => {
    let increase = $(".offer1000").data("increase")
    submit_bid(increase)
  });
  
  $(".restart_bid").on("click", () => {
    channel.push("restart")
  });
  
  $(".withdraw_bid").on("click", () => {
    if (bid_msg.top_bid.bidder != window.user_id)
      return;
  
    channel.push("withdraw", {
      token_id: bid_msg.next_token_id, 
      bid: bid_msg.top_bid.bid,
    });
  });  
})
