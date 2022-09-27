import express from 'express';
import OpenTok from 'opentok';
import pug from 'pug';
import * as dotenv from 'dotenv'

dotenv.config()
const app = express();
const ot = new OpenTok(process.env.OT_API_KEY, process.env.OT_API_SECRET);
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

app.get('/_/health', async (req, res) => {
  res.send('OK');
});

app.get('/session', async (req, res) => {
  ot.createSession({ mediaMode: "routed" }, function (err, session) {
    if (err) throw err;
    res.json({session: session.sessionId})
  });
});

app.get('/video', async (req, res) => {
  const sessionID = req.query.session;
  const token = ot.generateToken(sessionID);
  res.send(pug.renderFile('views/video.pug', { apiKey: process.env.OT_API_KEY, sessionID: sessionID, token: token }));
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
});