import { useEffect, useState } from "react";
import { createClient } from "@supabase/supabase-js";
import './App.css'

const supabase = createClient("https://upvlhrqfpsqxgsckvldl.supabase.co", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVwdmxocnFmcHNxeGdzY2t2bGRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI3ODAyOTIsImV4cCI6MjA0ODM1NjI5Mn0.qEA0ZQJr0l5j7WPhquo63LXis-TU--6lNvLRNEYIXyY");

function App() {
  const [countries, setCountries] = useState([]);

  useEffect(() => {
    getCountries();
  }, []);

  async function getCountries() {
    const { data } = await supabase.from("countries").select();
    setCountries(data);
  }

  return (
    <ul>
      {countries.map((country) => (
        <li key={country.name}>{country.name}</li>
      ))}
    </ul>
  );
}

export default App;