// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken, user_id: window.user_id}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("auction:" + window.auction_id)
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

let render_msg = (msg) => {
  if (msg.top_bid.bid > 0 ) {
    $('.top-bid').text(msg.top_bid.bid)
    $('.top-bidder').text(msg.top_bid.bidder)
  }

  window.bid_msg = msg

  $(".bidder_count").text(msg.bidder_count)
  $(".participant_count").text(msg.participant_count)
  $(".offer200").text(msg.increases[0])
  $(".offer200").data("increase", msg.increases[0])
  $(".offer500").text(msg.increases[1])
  $(".offer500").data("increase", msg.increases[1])
  $(".offer1000").text(msg.increases[2])
  $(".offer1000").data("increase", msg.increases[2])

  let commission = "（加佣金" + msg.commission_rate + "% 即" + msg.commissions + "元)"
  $(".commission").text(commission)
}

function show_restart(show) {
  restart_elem = $(".restart_bid")
  if (show) {
    if (restart_elem.css("display") != "block")
      restart_elem.show()
  } 
  else {
    if (restart_elem.css("display") != "none")
      restart_elem.hide()
  }
}

function element_visible(elem, visible) {
  if (visible) {
    if (elem.css("display") != "block")
    elem.show()
  } 
  else {
    if (elem.css("display") != "none")
    elem.hide()
  }
}

function countdown() {
  let elem = $(".countdown")
  if (window.bid_msg == "undefined" || window.bid_msg == null) {
    element_visible($(".restart_bid"), true)
    element_visible($(".withdraw_bid"), false)
    elem.text("--")
    return
  }

  element_visible($(".restart_bid"), false)
  
  let bid_at = new Date(window.bid_msg.bid_at || new Date())
  let now = new Date()
  let count = 30 - Math.round((now - bid_at) / 1000)
  if (count > 0) {
    elem.text(count)
    if (window.bid_msg.top_bid.bidder == window.user_id) {
      element_visible($(".withdraw_bid"), count > 20)
    } else {
      element_visible($(".withdraw_bid"), false)
    }
  } else {
    elem.text('已结束')
    element_visible($(".restart_bid"), true)
    element_visible($(".withdraw_bid"), false)
  }

}

window.setInterval(countdown, 1000)

channel.on("bidder_join", msg => {
  console.log("Bidder join: ", msg)
  render_msg(msg)
})

channel.on("countdown", msg => {
  $('.countdown').text(msg.counter)
  // render_msg(msg)
})

channel.on("bid_endded", msg => {
  $('.countdown').text('拍卖结束')
});

channel.on("on_new_bid", msg => {
  console.log("on_new_bid:" , msg)
  render_msg(msg)
});

channel.on("on_restart", msg => {
  render_msg(msg)
  channel.push("ping")
})

channel.on("on_withdraw", msg => {
  console.log("on_withdraw:" , msg)

  render_msg(msg)
})

export {socket, channel}
//export default socket
