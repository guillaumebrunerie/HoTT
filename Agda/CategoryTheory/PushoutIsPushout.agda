{-# OPTIONS --without-K #-}

open import Base

module CategoryTheory.PushoutIsPushout {i} (A B C : Set i)
  (f : C → A) (g : C → B) where

import CategoryTheory.PushoutDef as PushoutDef
open PushoutDef A B C f g
import CategoryTheory.PushoutUP as PushoutUP
open PushoutUP A B C f g (λ _ → unit)

pushout-cone : cone pushout
pushout-cone = (left , right , glue)

factor-pushout : (E : Set i) → (cone E → (pushout → E))
factor-pushout E (A→top , B→top , h) = pushout-rec-nondep E A→top B→top h

pushout-is-pushout : is-pushout pushout pushout-cone
pushout-is-pushout E ⦃ tt ⦄ = iso-is-eq _ (factor-pushout E)
  (λ y → map (λ u → _ , _ , u)
             (funext-dep (λ x → pushout-β-glue-nondep E (cone.A→top y)
                                  (cone.B→top y) (cone.h y) x)))
  (λ f → funext-dep (pushout-rec _ (λ a → refl _) (λ b → refl _)
    (λ c → trans-fx≡gx
             (pushout-rec-nondep E (f ◯ left) (f ◯ right)
              (λ c' → map f (glue c')))
             f (glue c) (refl _)
             ∘ (map (λ u → ! u ∘ map f (glue c))
                  (pushout-β-glue-nondep E (f ◯ left) (f ◯ right)
                   (λ c' → map f (glue c')) c)
                  ∘ opposite-left-inverse (map f (glue c))))))
