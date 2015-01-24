module Control.Monad.ST.Unsafe where

import Control.Monad.ST
import System.IO.Unsafe 
import Unsafe.Coerce

{-|
This is like 'unsafePerformIO', but for the 'ST' monad. Highly unsafe, only
use when you really know what you're doing. The same precations as 
for 'unsafePerformIO' apply:

If the ST computation wrapped in 'unsafePerformST' performs side
effects, then the relative order in which those side effects take
place (relative to the main I\/O trunk, or other calls to
'unsafePerformST') is indeterminate.  Furthermore, when using
'unsafePerformST' to cause side-effects, you should take the following
precautions to ensure the side effects are performed as many times as
you expect them to be.  Note that these precautions are necessary for
GHC, but may not be sufficient, and other compilers may require
different precautions:

  * Use @{\-\# NOINLINE foo \#-\}@ as a pragma on any function @foo@
        that calls 'unsafePerformST'.  If the call is inlined,
        the S\/T may be performed more than once.

  * Use the compiler flag @-fno-cse@ to prevent common sub-expression
        elimination being performed on the module, which might combine
        two side effects that were meant to be separate.

  * Make sure that the either you switch off let-floating (@-fno-full-laziness@), or that the 
        call to 'unsafePerformST' cannot float outside a lambda.  For example, 
        if you say:
        @
           f x = unsafePerformST (newSTRef [])
        @
        you may get only one reference cell shared between all calls to @f@.
        Better would be
        @
           f x = unsafePerformST (newSTRef [x])
        @
        because now it can't float outside the lambda.

|-} 

unsafePerformST :: ST s a -> a
unsafePerformST m = 
   unsafePerformIO $ stToIO $  -- unsafely do it
   unsafeCoerce m -- convert tot ST Realworld a
{-# NOINLINE unsafePerformST #-}  
