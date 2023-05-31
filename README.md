# Setup
- Đăng ký Skyway api : https://console-webrtc-free.ecl.ntt.com/users/registration
- Tạo Applications và lấy API Key ( chú ý mục Available domains sẽ sử dụng key cho môi trường dó)
- setup ENV: `npm run setup:env`
# Run with Docker
- build docker `npm run build`
- run docker `npm run up`
- view log front-end  `npm run log:fe`
- view log back-end  `npm run log:be`
- view log proxy  `npm run log:proxy`
- PORT FE : 8080 , PORT BE : 8001
# Run normal
- run front-end `npm run start:fe`
- run back-end `npm run start:be`

# Config domain ( deploy )
- đăng ký tên miền
- sửa config SN sang cloudflare
#### Sửa DNS -> Records và thêm record
1. Type: A , Name: thopt.website(tên miền đã đăng ký), Context : 94.237.79.161 (IP của server)
2. Type: CNAME , Name: api(subdomain - dùng cho trỏ đến backend), Context : thopt.website (phần nginx sẽ handle server_name: api.thopt.website và trỏ đến Port cuả Backend  )
3. sửa .env trong proxi DOMAIN= ip của server mình
4. sửa .env trong vue-rtc DOMAIN_BE= subdomain trỏ đến cổng backend (https://api.thopt.website)
