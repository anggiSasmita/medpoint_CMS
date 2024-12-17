import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { createClient } from "@supabase/supabase-js";
import { FaHome, FaCog, FaUser, FaSignOutAlt } from "react-icons/fa"; // React Icons

const supabase = createClient(
 'https://gercqdrpnwbungwtmigf.supabase.co', 
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcmNxZHJwbndidW5nd3RtaWdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTM2MjEsImV4cCI6MjA0OTMyOTYyMX0.hR0Ndvu6lMmGmQDww6_G5SFMfdghUUcc5mkZpwKwPn0'
);

const Dashboard: React.FC = () => {
  const [username, setUsername] = useState<string | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUser = async () => {
      const { data, error } = await supabase.auth.getUser();
      if (error || !data.user) {
        navigate("/"); // Redirect jika tidak ada user yang login
      } else {
        const email = data.user.email || null;
        setUsername(email);
      }
    };

    fetchUser();
  }, [navigate]);

  // Handle Logout
  const handleLogout = async () => {
    await supabase.auth.signOut(); // Logout dari Supabase
    navigate("/"); // Redirect ke halaman login setelah logout
  };

  return (
    <div className="flex h-screen">
      {/* Sidebar */}
      <aside className="w-1/4 bg-white text-gray-800 shadow-lg flex flex-col items-start p-6">
        {/* Logo Mediverse */}
        <div className="w-full flex justify-center mb-6">
          <img
            alt="Mediverse logo"
            className="h-10"
            src="/mediverse.png"
          />
        </div>

        {/* Navigation Items */}
        <li className="flex items-center gap-4 px-4 py-3 rounded-lg hover:bg-gradient-to-r hover:from-purple-600 hover:to-blue-400 hover:text-white cursor-pointer transition duration-300 min-h-[40px] w-full">
          <FaHome className="text-lg" />
          <span>Dashboard</span>
        </li>
        <li className="flex items-center gap-4 px-4 py-3 rounded-lg hover:bg-gradient-to-r hover:from-purple-600 hover:to-blue-400 hover:text-white cursor-pointer transition duration-300 min-h-[40px] w-full">
          <FaCog className="text-lg" />
          <span>Settings</span>
        </li>
        <li className="flex items-center gap-4 px-4 py-3 rounded-lg hover:bg-gradient-to-r hover:from-purple-600 hover:to-blue-400 hover:text-white cursor-pointer transition duration-300 min-h-[40px] w-full">
          <FaUser className="text-lg" />
          <span>Profile</span>
        </li>
        {/* Logout */}
        <li
          className="flex items-center gap-4 px-4 py-3 rounded-lg hover:bg-gradient-to-r hover:from-purple-600 hover:to-blue-400 hover:text-white cursor-pointer transition duration-300 min-h-[40px] w-full"
          onClick={handleLogout} // Menambahkan onClick untuk logout
        >
          <FaSignOutAlt className="text-lg" />
          <span>Logout</span>
        </li>
      </aside>

      {/* Main Content */}
      <main className="w-3/4 bg-gradient-to-r from-purple-600 to-blue-500 text-white flex flex-col justify-center items-center p-10">
        {/* Dashboard Content */}
        <div className="flex flex-col items-center justify-center w-full h-full mt-10">
          <h1 className="text-5xl font-extrabold mb-2">Welcome to the Dashboard</h1>
          <p className="text-lg">
            Selamat datang,{" "}
            <span className="font-semibold">{username || "Guest"}</span>!
          </p>
        </div>
      </main>
    </div>
  );
};

export default Dashboard;
