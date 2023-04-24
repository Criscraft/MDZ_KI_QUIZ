const { Sequelize, DataTypes, Model } = require('sequelize');


const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: 'quizdb.db'
});

class Question extends Model {}

Question.init({
    // Model attributes are defined here
    question_id: {
        type: DataTypes.STRING,
        primaryKey: true
    },
    option0Count: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    option1Count: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    option2Count: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    option3Count: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    option_correct: {
        type: DataTypes.INTEGER,
        allowNull: false,
    }
    }, {
    // Other model options go here
    sequelize, // We need to pass the connection instance
    modelName: 'Question', // We need to choose the model name
    timestamps: true,
    createdAt: true,
    updatedAt: false

    }
);


class GameSession extends Model {}

GameSession.init({
    // Model attributes are defined here
    gamesession_id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    // time: {
    //     type: DataTypes.DATE,
    //     allowNull: false,
    // },
    json_version: {
        type: DataTypes.STRING,
    },
    }, {
    // Other model options go here
    sequelize, // We need to pass the connection instance
    modelName: 'GameSession', // We need to choose the model name
    timestamps: true,
    createdAt: true,
    updatedAt: false
    }
);


class Quizevent extends Model {}

Quizevent.init({
    // Model attributes are defined here
    quizevent_id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    question_id: {
        type: DataTypes.STRING,
        references: {
          // This is a reference to another model
          model: Question,
          // This is the column name of the referenced model
          key: 'question_id'
        }
      },
    gamesession_id: {
        type: DataTypes.INTEGER,
        references: {
          model: GameSession,
          key: 'gamesession_id'
        }
      },
    option_chosen: {
        type: DataTypes.INTEGER,
        allowNull: false,
    }
    }, {
    // Other model options go here
    sequelize, // We need to pass the connection instance
    modelName: 'Quizevent', // We need to choose the model name
    timestamps: false
    }
);


async function register_gamesession(json_version){
    return new Promise(async (resolve) => {
        const new_instance = await GameSession.create({ json_version: json_version });
        resolve(new_instance.dataValues["gamesession_id"]);
      });
}


async function process_quizevent(question_id, gamesession_id, option_chosen, option_correct){
    return new Promise(async (resolve) => {
        // Check if the question_id exists.
        var question = await Question.findByPk(question_id);
        if (question === null) {
            // If it does not, we create the question entry.
            question = await Question.create({ question_id : question_id, option_correct : option_correct, option0Count : 0, option1Count : 0, option2Count : 0, option3Count : 0 });
        } 
        
        // Increment the question counter.
        var column = "";
        switch(option_chosen) {
            case 0:
                column = "option0Count";
                break;
            case 1:
                column = "option1Count";
                break;
            case 2:
                column = "option2Count";
                break;
            case 3:
                column = "option3Count";
                break;
        }
        await question.increment(column);

        // Add an entry to the quizevents.
        await Quizevent.create({ question_id : question_id, gamesession_id : gamesession_id, option_chosen : option_chosen });

        resolve();
      });
}




function get_db(){
    return sequelize
}

module.exports = { 
    "get_db" : get_db,
    "register_gamesession" : register_gamesession,
    "process_quizevent" : process_quizevent
}