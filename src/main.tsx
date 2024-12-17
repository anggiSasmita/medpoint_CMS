import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css'; // Import global styles
import App from './App'; // Import App yang berisi semua Routes

const root = ReactDOM.createRoot(document.getElementById('root') as HTMLElement);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
