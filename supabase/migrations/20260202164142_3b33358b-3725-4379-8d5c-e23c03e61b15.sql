-- Create a view for public order tracking that only exposes non-sensitive data
CREATE VIEW public.order_tracking AS
SELECT 
  id,
  tracking_id,
  status,
  created_at,
  updated_at
FROM public.orders
WHERE tracking_id IS NOT NULL;

-- Drop the overly permissive tracking policy
DROP POLICY IF EXISTS "Anyone can view orders by tracking_id" ON public.orders;

-- Add UPDATE policy for admins only
CREATE POLICY "Admins can update orders"
ON public.orders
FOR UPDATE
USING (
  public.has_role(auth.uid(), 'admin')
);

-- Add INSERT policy for order_status_history for admins
CREATE POLICY "Admins can insert order status history"
ON public.order_status_history
FOR INSERT
WITH CHECK (
  public.has_role(auth.uid(), 'admin')
);