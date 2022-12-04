# messenger
A one message-room messenger app with a web interface &amp; mobile app versions.

## Features
* Unicode messages
* Media: images, videos, files
* "Response" messages
* View links, images + videos, files separately
* Search function
* Dark mode

## Implementation Details

### Database details

#### `messages`
* `message_id`: Message id, could be hashed or not. `u32`
* `sender_id`: Foreign key to `users:user_id`.
* `timestamp`: Unix timestamp to the microsecond level. `timestamp`
* `is_img`: `bool`
* `is_vid`: `bool`
* `is_file`: `bool`
* `has_link`: `bool`
* `msg_body`: `text`

#### `users`    
* `user_id`: User id, could be hashed or not. `u8`.
* `settings`
    * `is_dark_mode`: `bool`

### Tech Stack
* Database: `MySQL`
* Backend: `Haskell` `Yesod`
* Frontend: `TypeScript`, likely `React` (subject to change)