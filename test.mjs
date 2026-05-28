import { createClient } from '@supabase/supabase-js';

const url = "https://lmgzsfivhdoczbgoshyu.supabase.co";
const key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtZ3pzZml2aGRvY3piZ29zaHl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg5NjU2NTQsImV4cCI6MjA5NDU0MTY1NH0.RxEztkIUOMtPDk90PrLbiKCitGA-5GlXAWWxiMxd36I";

const supabase = createClient(url, key);

async function test() {
    console.log("Attempting insert...");
    const { data, error } = await supabase
      .from('site_data')
      .upsert(
        { key: 'test', value: { testing: 123 }, updated_at: new Date().toISOString() },
        { onConflict: 'key' }
      );
    console.log("Result:", data);
    if (error) {
        console.error("Error:", error);
    }
}
test();
