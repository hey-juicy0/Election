const express = require('express');
const bodyParser = require('body-parser');
const { google } = require('googleapis');
const app = express();
const PORT = 3000;

// JSON 데이터 파싱을 위한 미들웨어 설정
app.use(bodyParser.json());

// Google Sheets API 클라이언트 설정
const auth = new google.auth.GoogleAuth({
  keyFile: 'key.json', // 서비스 계정 파일 경로
  scopes: ['https://www.googleapis.com/auth/spreadsheets'], // 권한 설정
});

const sheets = google.sheets({ version: 'v4', auth });

app.post('/upload', async (req, res) => {
  const data = req.body; 

  if (!Array.isArray(data) || data.length === 0) {
    return res.status(400).send('Invalid input data');
  }

  const values = data.map(item => [
    item.birthYear,
    item.gender,
    item.MNA,
    item.PR
  ]);

  const spreadsheetId = '18L6LgvuSxCVuhquylUzqQak4Y2FIjSoaJ8cAighgbNg';
  const range = '종로구'; 

  try {
    const response = sheets.spreadsheets.values.append({
        spreadsheetId,
        range,
        valueInputOption: 'RAW',
        resource: { values },
    });

    res.status(200).send('Data appended successfully');
  } catch (error) {
    console.error('Error appending data:', error);
    res.status(500).send('Error appending data');
  }
});

// 서버 시작
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
