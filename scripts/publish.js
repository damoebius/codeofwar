/**
 * Created by david on 27/09/16.
 */
const fs = require('fs');
const http = require('http');

var confmodule = __dirname + '/.codeofwar';
if (!fs.existsSync(confmodule)) {
    console.error("please login first : npm run login <username> <password>");
    process.exit();
}
const conf = JSON.parse(fs.readFileSync(confmodule));

var filename = 'assets/htdocs/bots/your_IA.js';
console.log('Publishing ' + filename);
fs.readFile(filename, 'utf8', function (err, data) {
    if (err) {
        console.error(err.message);
        process.exit();
    }

    var post_data = JSON.stringify({
        'content': data,
        'filename': filename,
        'apiKey': conf.apiKey
    });

    var host = 'qualif.codeofwar.net';
    if (process.argv.indexOf('dev') != -1) {
        host = 'localhost';
    }

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
            if (res.statusCode != 200) {
                console.error("Error Code : " + res.statusCode);
            }
            console.log(data);
        });
    });

    request.write(post_data);
    request.end();
});
