{-# LANGUAGE CPP #-}
{-# LANGUAGE OverloadedStrings #-}

module Clash.Tests.Core.Subst (tests) where

#if MIN_VERSION_ghc(9,0,0)
import           GHC.Types.SrcLoc        (noSrcSpan)
#else
import           SrcLoc                  (noSrcSpan)
#endif

import           Test.Tasty
import           Test.Tasty.HUnit

import           Clash.Core.Name         (Name(..), NameSort(..))
import           Clash.Core.Term         (Term(Var))
import           Clash.Core.Type         (ConstTy(..), Type(ConstTy))
import           Clash.Core.Subst
import           Clash.Core.VarEnv
import           Clash.Core.Var          (IdScope(..), Var(..))
import           Clash.Unique            (Unique)

fakeName :: Name a
fakeName =
  Name
    { nameSort=User
    , nameOcc="fake"
    , nameUniq=0
    , nameLoc=noSrcSpan
    }

unique :: Unique
unique = 20

termVar :: Var Term
termVar = Id {
    varName = fakeName {nameUniq=unique, nameOcc="term"}
  , varUniq = unique
  , varType = ConstTy (TyCon fakeName)
  , idScope = LocalId
  }

term1 :: Term
term1 = Var termVar

tests :: TestTree
tests =
  testGroup
    "Clash.Tests.Core.Subst"
    [ testCase "deShadow type/term" $
        term1 @=? deShadowTerm (extendInScopeSet emptyInScopeSet termVar) term1
    ]
