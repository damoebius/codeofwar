/**
 * Created by david on 27/09/16.
 */
const fs = require('fs');
const http = require('http');

if (process.argv.length != 4) {
    console.warn("usage : login <username> <password>");
    process.exit();
}
var username = process.argv[2];
var password = process.argv[3];

var filename = __dirname + '/.codeofwar';
console.log('Login ' + username);

var post_data = JSON.stringify({
    'username': username,
    'password': password
});

var options = {
    host: 'localhost',
    port: '8092',
    path: '/api/login',
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(post_data)
    }
};

var request = http.request(options, function (res) {
    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });
    res.on('end', () => {
        if (res.statusCode == 200) {
            var content = {
                apiKey: JSON.parse(data)
            };
            fs.writeFileSync(filename, JSON.stringify(content));
            console.log("login successful");
        } else {
            console.error("Error Code : " + res.statusCode);
        }
    });
});

request.write(post_data);
request.end();
