const db = require('./db');
const express = require('express');

const app = express();
app.use(express.json());
const port = 3000;

app.get('/', (req, res) => {
    res.status(200);
    res.send('Hello World!');
});

app.get('/startgame/jsonVersion/:jsonVersion', async (req, res) => {
    // Create new game session entry.
    var game_session_id = await db.register_gamesession(req.params["jsonVersion"]);
    res.status(200);
    // console.log(game_session_id);
    res.send(String(game_session_id));
});


app.post('/quizevent', async (req, res) => {
    console.log(req.body);
    
    var myjson = req.body;
    console.log(myjson);
    await db.process_quizevent(myjson["question_id"], myjson["gamesession_id"], myjson["option_chosen"], myjson["option_correct"])
    res.status(200);
    res.send('Quizevent registered.');
});


(async function main() {
    try {
        const sequelize = db.get_db()
        await sequelize.authenticate();
        console.log('Connection has been established successfully.');
        
        await sequelize.sync({ force: true });
        console.log("All models were synchronized successfully.");

        app.listen(port, () => {
            console.log(`Example app listening on port ${port}`)
        })
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
})();


