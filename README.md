line-echobot-heroku
===================

LINE Messaging API echo bot. [Official Ruby SDK's example](https://github.com/line/line-bot-sdk-ruby/blob/master/examples/echobot/app.rb) with [tweaks for Heroku](https://github.com/kyanny/line-echobot-heroku/commit/d56e1653cfe41cc96867fc1b0583705eb56db374).

Setup
-----

### 1. Get Channel Secret and Channel Access Token

- Open [LINE Business Center](https://business.line.me/ja/)
- Go to [Accounts (アカウントリスト)](https://business.line.me/accounts)
- Messaging API -> LINE Developers
- Channel Secret -> SHOW -> copy and memo it
- Channel Access Token -> copy and memo it

### 2. Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/kyanny/line-echobot-heroku/tree/master)

- Fill `LINE_CHANNEL_SECRET` with Channel Secret
- Fill `LINE_CHANNEL_TOKEN` with Channel Access Token

### 3. Add FIXIE Outbound IPs to Server IP Whitelist

At dashboard.heroku.com:

- Manage App -> Overview -> Fixie
- Account -> Outbound IPs -> copy and memo it

At developers.line.me:

- Server IP Whitelist -> IP address -> Fill FIXIE Outbound IPs -> ADD
- Add alL Outbound IPs

### 4. Set Webhook URL

At dashboard.heroku.com:

- Open app -> Copy app URL and memo it

At developers.line.me:

- Basic information -> EDIT -> Webhook URL -> Fill it with `${APP_URL}/callback` -> SAVE

### 5. Add LINE@ account to your friend. Talk to bot.
