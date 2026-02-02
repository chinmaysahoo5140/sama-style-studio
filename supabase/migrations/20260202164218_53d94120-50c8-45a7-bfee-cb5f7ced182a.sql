-- Drop the security definer view and recreate with SECURITY INVOKER
DROP VIEW IF EXISTS public.order_tracking;

-- Create view with explicit SECURITY INVOKER (default, but explicit for clarity)
CREATE VIEW public.order_tracking 
WITH (security_invoker = true) AS
SELECT 
  id,
  tracking_id,
  status,
  created_at,
  updated_at
FROM public.orders
WHERE tracking_id IS NOT NULL;

-- Grant SELECT on the view to public for order tracking lookups
GRANT SELECT ON public.order_tracking TO anon, authenticated;