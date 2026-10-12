
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const { createClient } = require('@supabase/supabase-js');

const app = express();
const PORT = process.env.PORT || 3000;

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'MediTech backend is running!' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

// Register a new user
app.post('/register', async (req, res) => {
  try {
    const { fullName, email, password } = req.body;

    if (
      typeof fullName !== 'string' ||
      !fullName.trim() ||
      typeof email !== 'string' ||
      !email.trim() ||
      typeof password !== 'string' ||
      password.length < 8
    ) {
      return res.status(400).json({
        message: 'Enter your full name, a valid email, and a password of at least 8 characters.'
      });
    }

    const { data, error } = await supabase.auth.signUp({
      email: email.trim(),
      password,
      options: {
        data: {
          full_name: fullName.trim()
        }
      }
    });

    if (error) {
      return res.status(400).json({ message: error.message });
    }

    res.status(201).json({
      message: data.session
        ? 'Registration successful.'
        : 'Registration received. Check your email to confirm your account.',
      user: data.user
        ? { id: data.user.id, email: data.user.email }
        : null,
      access_token: data.session?.access_token ?? null
    });
  } catch (error) {
    console.error('Registration failed:', error.message);
    res.status(500).json({ message: 'Registration failed.' });
  }
});

// Log in an existing user
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (
      typeof email !== 'string' ||
      !email.trim() ||
      typeof password !== 'string' ||
      !password
    ) {
      return res.status(400).json({
        message: 'Email and password are required.'
      });
    }

    const { data, error } = await supabase.auth.signInWithPassword({
      email: email.trim(),
      password
    });

    if (error) {
      return res.status(401).json({
        message: 'Invalid email or password, or account confirmation is required.'
      });
    }

    res.json({
      message: 'Login successful.',
      access_token: data.session.access_token,
      user: {
        id: data.user.id,
        email: data.user.email
      }
    });
  } catch (error) {
    console.error('Login failed:', error.message);
    res.status(500).json({ message: 'Login failed.' });
  }
});

// Retrieve the logged-in user's profile
app.get('/profile', async (req, res) => {
  try {
    const authHeader = req.headers.authorization || '';
    const token = authHeader.startsWith('Bearer ')
      ? authHeader.slice(7)
      : '';

    if (!token) {
      return res.status(401).json({
        message: 'Authentication token is required.'
      });
    }

    const { data: userData, error: authError } =
      await supabase.auth.getUser(token);

    if (authError || !userData.user) {
      return res.status(401).json({
        message: 'Invalid or expired token.'
      });
    }

    const userClient = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_ANON_KEY,
      {
        global: {
          headers: {
            Authorization: `Bearer ${token}`
          }
        },
        auth: {
          persistSession: false,
          autoRefreshToken: false
        }
      }
    );

    const { data: profile, error: profileError } = await userClient
      .from('profiles')
      .select('full_name')
      .eq('id', userData.user.id)
      .single();

    if (profileError) {
      console.error('Profile lookup failed:', profileError.message);
      return res.status(404).json({
        message: 'Profile not found.'
      });
    }

    res.json({
      fullName: profile.full_name,
      email: userData.user.email
    });
  } catch (error) {
    console.error('Profile request failed:', error.message);
    res.status(500).json({
      message: 'Could not retrieve profile.'
    });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`MediTech backend running on port ${PORT}`);
});
