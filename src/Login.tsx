import React, { useState } from 'react';
import { createClient } from '@supabase/supabase-js';
import { useNavigate } from 'react-router-dom';
import { FaEnvelope, FaLock, FaEye, FaEyeSlash, FaSignInAlt } from 'react-icons/fa'; // Import icons from react-icons

const supabase = createClient(
  'https://gercqdrpnwbungwtmigf.supabase.co', // Pastikan URL ini benar
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcmNxZHJwbndidW5nd3RtaWdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTM2MjEsImV4cCI6MjA0OTMyOTYyMX0.hR0Ndvu6lMmGmQDww6_G5SFMfdghUUcc5mkZpwKwPn0'
);

const App: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate(); //untuk navigasi

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const handleLogin = async () => {
    if (!email || !password) {
      setError('Email dan kata sandi harus diisi.');
      return;
    }

    setIsLoading(true);
    setError(null);

    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    setIsLoading(false);

    if (error) {
      setError('Gagal masuk: ' + error.message);
    } else {
      setError(null);
      alert('Login berhasil! Selamat datang, Anggi');
      navigate('/Dashboard'); // Redirect ke dashboard setelah login 
    }
  };

  return (
    <div className="w-full h-screen flex">
      <div className="w-full md:w-1/2 p-8 flex flex-col justify-center">
        <div className="mt-[-8px] mb-20">
          <img
            alt="Mediverse logo"
            className="h-8"
            src="/mediverse.png"
          />
        </div>
        
        <div className="w-full h-screen flex items-center justify-center">
        <div className="max-w-md mx-auto">
          <div className="mb-2">
            <h2 className="text-4xl font-bold text-left">Selamat Datang</h2> {/* Updated to larger and bold */}
            <p className="text-sm text-gray-600 mb-6 font-bold text-left mt-2">Masuk dan kelola dashboard Mediverse Anda sekarang</p> {/* Added mt-4 here */}
          </div>

          {error && <p className="text-red-500 text-sm">{error}</p>}
          
          <form>
            <div className="mb-2">
              <label className="text-sm font-bold text-gray-700" htmlFor="email">Email</label>
            </div>
            <div className="mb-4 flex items-center border border-gray-300 rounded-lg max-w-md mx-auto">
              <FaEnvelope className="text-gray-500 ml-3" />
              <input
                className="w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-purple-500 rounded-l-lg"
                id="email"
                placeholder="Masukkan email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>

            <div className="mb-2">
              <label className="text-sm font-bold text-gray-700" htmlFor="password">Kata Sandi</label>
            </div>
            <div className="mb-4 flex items-center border border-gray-300 rounded-lg max-w-md mx-auto">
              <FaLock className="text-gray-500 ml-3" />
              <input
                className="w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-purple-500 rounded-l-lg"
                id="password"
                placeholder="Masukkan kata sandi"
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
              <span className="cursor-pointer pr-3" onClick={togglePasswordVisibility}>
                {showPassword ? <FaEyeSlash className="text-gray-500" /> : <FaEye className="text-gray-500" />}
              </span>
            </div>
            
            <div className="mb-6 flex justify-end">
              <a className="text-sm text-purple-500 hover:text-purple-700" href="#">
                Lupa Kata Sandi?
              </a>
            </div>
            
            <div className="flex justify-end">
              <button
                className="bg-purple-500 hover:bg-purple-600 text-white font-medium py-2 px-8 flex items-center justify-center rounded-full focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-opacity-50 transition-all duration-200 text-sm"
                type="button"
                onClick={handleLogin}
                disabled={isLoading}
              >
                {isLoading ? (
                  'Loading...'
                ) : (
                  <>
                    MASUK SEKARANG
                    <FaSignInAlt className="ml-2" />
                  </>
                )}
              </button>
            </div>
          </form>
        </div>
      </div>
      </div>

      <div
        className="w-1/2 h-full" style={{ background: 'linear-gradient(to bottom, #1E3A8A, #D6A7F7, #8E44AD)' }}>
  
      <div className="flex items-center justify-center h-full bg-black bg-opacity-50 flex-col">
        <div className="mb-16"> {/* Mengatur margin bawah untuk jarak antara logo dan gambar dokter */}
          <img
            alt="Mediverse logo"
            className="h-10"
            src="/logopt.png"
          />
        </div>

        <div className="text-center text-white">
          <img
            alt="a doctor"
            className="mx-auto mb-6"
            height="300"
            src="/doctor.png"
            width="300"
          />

            <p style={{ fontSize: '30px', marginTop: '1rem' }}>Your Personal</p>
            <p style={{ fontSize: '30px' }}>Healthcare Assistant</p>

          </div>
        </div>
      </div>
    </div>
  );
};

export default App;