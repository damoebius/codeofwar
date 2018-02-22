/**
 * Created by david on 27/09/16.
 */
const fs = require('fs');
const http = require('http');

if (process.argv.length != 3) {
    console.warn("usage : publish <filename>");
    process.exit();
}
var filename = process.argv[2];
console.log('Publishing ' + filename);
fs.readFile(filename, 'utf8', function (err, data) {
    if (err) {
        console.error(err.message);
        process.exit();
    }

    var post_data = JSON.stringify({
        'content': data,
        'filename': filename
    });

    var options = {
        host: 'localhost',
        port: '8092',
        path: '/api/publish',
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
            console.log(data);
        });
    });

    request.write(post_data);
    request.end();
});
