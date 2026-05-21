import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fs from 'fs';

dotenv.config();

const url = process.env.VITE_SUPABASE_URL;
const key = process.env.VITE_SUPABASE_ANON_KEY;

console.log('Testing Supabase credentials from .env...');
console.log('URL:', url);
console.log('Key length:', key ? key.length : 0);

if (!url || !key) {
  console.error('Error: VITE_SUPABASE_URL or VITE_SUPABASE_ANON_KEY is missing in .env');
  process.exit(1);
}

const supabaseClient = createClient(url, key);

async function runTest() {
  try {
    // 1. Test table query
    console.log('\n--- Querying site_data table ---');
    const { data: tableData, error: tableError } = await supabaseClient
      .from('site_data')
      .select('*');
    
    if (tableError) {
      console.error('Table Query Error:', tableError);
    } else {
      console.log('Table Query Success! Rows found:', tableData.length);
      console.log('Rows:', JSON.stringify(tableData, null, 2));
    }

    // 2. Test Storage Bucket
    console.log('\n--- Querying media storage bucket ---');
    const { data: bucketData, error: bucketError } = await supabaseClient
      .storage
      .getBucket('media');

    if (bucketError) {
      console.error('Storage Bucket media Error:', bucketError);
    } else {
      console.log('Storage Bucket media Success! Info:', bucketData);
    }

    // 3. List files in media bucket
    console.log('\n--- Listing files in media bucket ---');
    const { data: filesData, error: filesError } = await supabaseClient
      .storage
      .from('media')
      .list('about', { limit: 100 });

    if (filesError) {
      console.error('List files in about/ Error:', filesError);
    } else {
      console.log('Files in about/ folder:', filesData);
    }

  } catch (err) {
    console.error('Unexpected error during test:', err);
  }
}

runTest();
