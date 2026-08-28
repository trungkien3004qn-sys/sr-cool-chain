import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabasePublishableKey =
  import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY

if (!supabaseUrl || !supabasePublishableKey) {
  throw new Error('Thiếu cấu hình kết nối Supabase trong .env.local')
}

export const supabase = createClient(
  supabaseUrl,
  supabasePublishableKey
)

// Cho đoạn JavaScript trong index.html sử dụng Supabase
window.supabaseClient = supabase

console.log('Supabase client đã được khởi tạo')