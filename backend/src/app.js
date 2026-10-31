const express = require('express');
const db = require('./config/database');

const app = express();

app.use(express.json());

app.get('/', (req, res) => {
    res.json({
        message: 'Selamat datang di API Backend Cyclefy',
        status: 'success'
    });
});

app.get('/api/health', (req, res) => {
    res.json({
        message: 'Cyclefy API is running',
        status: 'success'
    });
});


app.get('/api/db-test', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT DATABASE() AS database_name');

        res.json({
            message: 'Database connected successfully',
            status: 'success',
            database: rows[0].database_name
        });
    } catch (error) {
        res.status(500).json({
            message: 'Database connection failed',
            status: 'error',
            error: error.message
        });
    }
});

module.exports = app;